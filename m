Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbXH3TE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbXH3TE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXH3TEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:04:21 -0400
Received: from gw.goop.org ([64.81.55.164]:54939 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXH3TEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:04:20 -0400
Message-ID: <46D714A9.4060103@goop.org>
Date: Thu, 30 Aug 2007 12:04:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christian Ehrhardt <lk@c--e.de>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: New x886-Setup code breaks HVM-XEN boot
References: <20070830141528.GA307@lisa.in-ulm.de>
In-Reply-To: <20070830141528.GA307@lisa.in-ulm.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt wrote:
> I am willing to do tests with the XEN guest and send any additional
> information that might be helpful. However, I cannot change the XEN host
> at this time.
>   

Are there any messages on the xen console ("xm dmesg")?  Or logs ("xm
log")?  What version of Xen are you using?  What does your domain config
file look like?

    J
