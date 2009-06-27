Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZF0JHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZF0JHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZF0JHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:07:37 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36736 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZF0JHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ETlPEzuPAwm1TY2Ci0nf5F28Q2P5Mba8kG5b7c8k8BfvXvQN+N5idNyVHf3h2d+EYU
         Kzx+2GPQC8dBRRzc4351EYqZEWhsq5zFUeMLlq/EKTroWJ4RuW1cFz9frH9CAkSqJ1S6
         Ei3c14o7ZjnA7YHSM6LUSxiwWl1x8h6mt76jg=
MIME-Version: 1.0
In-Reply-To: <20090627185749.065bcab4@linux-uvcl.site>
References: <20090627185749.065bcab4@linux-uvcl.site>
Date: Sat, 27 Jun 2009 11:07:39 +0200
Message-ID: <8db1092f0906270207j7dafab3ak69fe52358e5eda98@mail.gmail.com>
Subject: Re: Kernel testing in a VM good idea?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: James Dolan <jamesdolan@clear.net.nz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/28 James Dolan <jamesdolan@clear.net.nz>:
> Are there any disadvantages to testing/developing a kernel in a VM ? (i
> luck the availability of hardware)

To testing I use 2 machines: PC (mainly use for development,
multimedia) and laptop (work, home etc.). Firstly I test kernel on PC.
When I'm sure, that kernel doesn't cause any filesystem/hardware
error, lost data, then I test it also on laptop. When You can't use
more than one computer, I think that is good idea testing/development
on VM, before use real machine.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
