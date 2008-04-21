Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYDUK5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYDUK5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYDUK5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:57:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:2154 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYDUK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fMFn2yYUNmUvVOxRA/NsfuVRav0u63fvXRZ3iyD9XGjJ7U0zBNzy6ifqrOvaUFqdfiYr1WJrJva6/kYLYmsmML0Saq7g/2gqX9Szcu7hSgHdFrg64IC4qLyhN5VGMDNllk8nET0lNr2JkzCzr190gaV5aL+2g4IUiG/V4lZnnCY=
Message-ID: <9a5eeacd0804210356t2b84bb40t7a266467c3699bd9@mail.gmail.com>
Date: Mon, 21 Apr 2008 13:56:58 +0300
From: "Matthias Andersson" <matthias.andersson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel panic
In-Reply-To: <9a5eeacd0804210350v79db27f0of73a29c55e2b7311@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a5eeacd0804210350v79db27f0of73a29c55e2b7311@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I upgraded to Ubuntu 8.04 (Hardy Heron) four days ago and with it the
2.6.24-16 kernel.
The kernel worked fine until yesterday when I booted up the machine I
was greeted by the following error message:

 /init: ./34: Can't open /scripts/functions
[   20.587228] kernel panic - not syncing: attempted to kill init!

What could have caused this failiure?
There were some upgrades installed before the final shutdown of the
system (prior to the kernel panic) but nothing system-critical.

//Matthias Andersson
