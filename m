Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbXJOU2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbXJOU2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXJOU22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:28:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:22861 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbXJOU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qckb5XpbsvlZFtijiKhG2iUpASrjZclNb/diCr1AVa6f88p68eWA1on/a+amrJIhZkcREVdaqqDeJ9uxx45rWz1SeKbjMF3ic5MNn8HS7BdM3XZvf9dsONhdF3NFdVUUmaGqg2E1JlQJYdxNQ+iCBmiPIaetLKuyEzJIK5Lus3U=
Message-ID: <d120d5000710151328k6f413b76i21809691d9a18fe8@mail.gmail.com>
Date: Mon, 15 Oct 2007 16:28:24 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] Input updates for 2.6.24-rc0
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200710131614.35356.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710131614.35356.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Linus,
>
> Please pull from:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
>        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>
> to receive updates for the input subsystem. You will get a bunch
> new drivers, fixes for existing ones and also input core will
> finally have proper locking.
>

*ping*

-- 
Dmitry
