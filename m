Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXKYTAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXKYTAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 14:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXKYTAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 14:00:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:44752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXKYTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JBxhpvwhbeSrmaGTZTgpNPgmibjwRtIAYldh9ymnLkfmPUJjhH3sJhnu8GGvXuLjKh3Ls9Dal8jK32iQPC2xXWvFYpeYDCL11oGijp8Skxd+7zsExaMb6yp5FkLckPUthKgge86jSZUfu97sxhvEJBdgBjKox6Vxy06WGROK7f0=
Message-ID: <c22ebab10711251059k23178e20if60936dec105cab6@mail.gmail.com>
Date: Sun, 25 Nov 2007 19:59:59 +0100
From: Jeroen <j.geusebroek@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: forcedeth ethernet driver & Low power state
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4749C0B5.3010309@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.XqgRE47bF/VjxtMudX1m05vea0g@ifi.uio.no>
	 <4749C0B5.3010309@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 25, 2007 7:36 PM, Robert Hancock <hancockr@shaw.ca> wrote:

> Are you sure forcedeth even supports that feature? I haven't seen any
> code for it, and certainly it should never be enabled by default..
>

The windows driver does. I have to disable it because otherwise I have lot's of
connection speed troubles. This is also what i see when I use a linux distro on
the server unfortunately I can't disable it.

-- 
Jeroen
