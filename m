Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbYIBMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbYIBMLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYIBMLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:11:05 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:40598 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYIBMLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W8mFbXPW8QYGfBicr+s3ycYdK+J+3tVV2clWLdshCMpOOVIrmroRQsCokgZrbN23QC
         +nbEL5XSmD+yf1kZxpIzPJbbsoBoeEE0K+OR1neMN/y9p7//3DZ+5phns1r3qSKSkB42
         0m1v5zRzEEPWHQ6CjoYh7aMR/KO1/C5dbziZA=
Message-ID: <82ecf08e0809020510s2b752d18i6a1901e87effc07a@mail.gmail.com>
Date: Tue, 2 Sep 2008 09:10:59 -0300
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Cc: "Alex Buell" <alex.buell@munted.org.uk>, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>, "Tomas Styblo" <tripie@cpan.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0808041644240.2152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080804211706.81d4aafa.alex.buell@munted.org.uk>
	 <Pine.LNX.4.44L0.0808041644240.2152-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Does anyone knows of problems concerning 152d:2338 attached to DVD recorders??

I have one of those here connected to a DVD-RW, it works fine for
reading, but I can't make it work for recording. K3B produce errors
while probing, newer cdrecords go as far as burning a CD halfway.

Here's a bug I opened a couple of months ago
https://bugzilla.redhat.com/show_bug.cgi?id=440289

(It really doesn't seem to matter which kernel I'm using - fedora,
ubuntu or plain vanilla)

I'll take a closer look at these patches here (and in kernel bug
9638), see if they make any difference

-- 
-
Thiago Galesi
