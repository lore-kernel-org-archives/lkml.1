Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYBWOKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYBWOKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760744AbYBWOJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:09:21 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:18333 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661AbYBWOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UMFHmACOmdvrXJJXJp17hnhyDVczL2rxVmISfl7YxC4t5VSNQ8kTWV8WWuhinyzV2XvpjEaeSJ0iOWIMzLV/cYA58BSK5iAi0zWPJ/8YKFgjn9SQ05JkJe0CrklxGe8lLVg+OUyubAu1ybDWBrZgEuw+A9165DBs2BSthDxk7vk=
Message-ID: <4d8e3fd30802230609w3f7bdc3gb43c6272aa9af49c@mail.gmail.com>
Date: Sat, 23 Feb 2008 15:09:16 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 00/10] IDE: Coding Style Fixes
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080223150436.6c09ce54@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223150436.6c09ce54@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 3:04 PM, Paolo Ciarrocchi
<paolo.ciarrocchi@gmail.com> wrote:
> Hi Bartlomiej,
>  The following 10 patches remove a huge number of errors and warnings
>  reported by checkpatch.pl from the IDE subsystem.
>
>  All the patches have been compile tested.

I forgot to mention that the series is against a linux-next tree cloned
a few hours ago.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
