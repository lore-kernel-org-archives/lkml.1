Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXGRFv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXGRFv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXGRFvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:51:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:10319 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXGRFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QDo0N3TLyfGRK6ITZ38c+RXt/3WHFu+8MiuE+mGl72bSOfhFBk8lSr42Z95BuYXjBT4Nx44MQd2XK/Xy9TCnhfMdMS2yRXzU/NXx+DblepsOCKXnWcRvyYrqIkEEjxZI5FoOT6jy/kgYMsEkOS+h31FE/7RHH12SXtohie5B128=
Message-ID: <469DAA52.1010803@gmail.com>
Date: Wed, 18 Jul 2007 14:51:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com> <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
In-Reply-To: <469BC34C.4080107@googlemail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, successfully reproduced here.  Will hunt down.

-- 
tejun
