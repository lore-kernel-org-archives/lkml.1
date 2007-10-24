Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXJXKFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXJXKFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXJXKFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:05:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:63526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXJXKFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=W58j8wm++xWEz06t3Gftk65Ftk06GyLNY0/44dKSR/40gWeO/Q6LmgO9zTfq0EhUOC7e9plO4hpXlhWd5nahlQsiAodsrO64YEfx1uOALvTkJlYPya6rMrM3Vv6UZun9pgLgmTxlUqVBO0Oq1jEqd/tufxiVfb9y3U2ZIRIzX6Q=
Message-ID: <661de9470710240305r7657431et3e8733fd830b735a@mail.gmail.com>
Date: Wed, 24 Oct 2007 15:35:09 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + fixing-the-warning-in-cgroupc.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, kamalesh@linux.vnet.ibm.com, menage@google.com
In-Reply-To: <200710240628.l9O6SZdI026422@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710240628.l9O6SZdI026422@imap1.linux-foundation.org>
X-Google-Sender-Auth: 72cf0926fcfc01a1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
> The patch titled
>      Fix warning in cgroup.c
> has been added to the -mm tree.  Its filename is
>      fixing-the-warning-in-cgroupc.patch
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>

Looks like commit 3bdf590eac36ac5930deb9552febee3ff18cd2d1 already
fixed this problem

Balbir
