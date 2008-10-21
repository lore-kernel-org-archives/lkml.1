Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYJUKAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYJUKAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYJUKAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:00:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:5872 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYJUKAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i6LNthlcd+i0o4/2PZNcBu59c1f6EarZg0tIGzjqmgdRuElRWqGJZlNcBe50orJR6B
         n99Nm7fcBGGu4VEvjXPDKpcdT4+MUVMvTrsjSxWf4vW9WIIotYbE6WDDytt4DSPuP+LD
         pPSagZ+P68Jqvv2GrPRETF3E6Lf0X75JEdjBk=
Message-ID: <241b8f7b0810210300t3f755e01s2c01a520702f04e2@mail.gmail.com>
Date: Tue, 21 Oct 2008 15:30:04 +0530
From: "Prabhu Chawandi" <prabhu.chavandi@gmail.com>
To: "Jike Song" <albcamus@gmail.com>
Subject: Re: History of Linux File !!!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <df9815e70810210205m36a6e47di41e52776511f8ba6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <241b8f7b0810210156k27a957c3i5df40f12068ea199@mail.gmail.com>
	 <df9815e70810210205m36a6e47di41e52776511f8ba6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks ..

 Or do v have any site ... where we can see all version as we see in WinCVS ?


Prabhu

On 10/21/08, Jike Song <albcamus@gmail.com> wrote:
> On Tue, Oct 21, 2008 at 4:56 PM, Prabhu Chawandi
> <prabhu.chavandi@gmail.com> wrote:
> > Hi,
> >
> >  Is there any way tosee the history of a linux kernel file....
> >
> > I mean .. when it is updated changed or what is the latest version ...
> >
>
> try :
>
> $ git whatchanged -p   path/to/your/file
>
> --
> Thanks,
> Jike
>
