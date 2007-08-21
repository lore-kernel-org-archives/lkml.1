Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXHUK4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXHUK4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbXHUK4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:56:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:59458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbXHUK4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=co1rhSkgyK7Hx3FftwaVzRaBc/FveRjBDilEYIMhxmmcjtsCKghMvVsVWYVLABVEBW4ZpDoKZCTn18lDevHapa/8ZHXiaDw3GGxQ0udBROMKSFZAVpo3hof6Njx0lDoOotJx9cPT7p/5dU6/TFFS9gcsAu8jYuguwaRD9UE6jH8=
Message-ID: <be1b757c0708210356s633db6c0m67601b250121ea0d@mail.gmail.com>
Date: Tue, 21 Aug 2007 12:56:12 +0200
From: "Karl Meyer" <adhocrocker@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070816141122.GA6625@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <20070813165821.GA19356@electric-eye.fr.zoreil.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
	 <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
	 <20070814224629.GB3495@electric-eye.fr.zoreil.com>
	 <20070816141122.GA6625@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fyi:
I do not know whether it is related to the problem, but since using
the version you told me there are these entries is my log:
frege Hangcheck: hangcheck value past margin!
frege Hangcheck: hangcheck value past margin!
frege Hangcheck: hangcheck value past margin!




2007/8/16, Francois Romieu <romieu@fr.zoreil.com>:
> (please do not remove the netdev Cc:)
>
> Francois Romieu <romieu@fr.zoreil.com> :
> [...]
> > If it does not work I'll dissect 0e4851502f846b13b29b7f88f1250c980d57e944
> > tomorrow.
>
> You will find a tgz archive in attachment which contains a serie of patches
> (0001-... to 0005-...) to walk from 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2
> to 0e4851502f846b13b29b7f88f1250c980d57e944 in smaller steps.
>
> Please apply 0001 on top of 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2. If it
> still works, apply 0002 on top of 0001, etc.
>
> --
> Ueimor
>
>
