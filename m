Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZKDUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZKDUMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbZKDUMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:12:16 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45481 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155AbZKDUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:12:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HNtqF0KH181Cmbj9hgU0BNj4VdNnj+cxQCM3nNWS9njd1+DFQ2xJYi1h7ydfyhAmBJ
         4iaJc2n3p+NQLkTIBx9dKFXMVYPmdOXVwqnXlpK+KJZjV33q5IC22HTX1qPmqANr5Ldj
         Rm5GsSAcXUaz9iyDUBLHOSolUQPk5SdkoUscA=
MIME-Version: 1.0
In-Reply-To: <20091104200714.GA24699@sucs.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.xRH.vre5KB@chimera>
	 <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com>
	 <87aazddvft.fsf@basilikum.skogtun.org>
	 <20091104200714.GA24699@sucs.org>
Date: Wed, 4 Nov 2009 21:12:18 +0100
Message-ID: <b637ec0b0911041212w227884d9w64ae3894eabb82a2@mail.gmail.com>
Subject: Re: [Bug #14372] ath5k wireless not working after rfkill [BISECTED]
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Harald Arnesen <harald@skogtun.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reporting. I guess I'll wait for -rc7 then.

On Wed, Nov 4, 2009 at 9:07 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Tue, Oct 27, 2009 at 10:42:46AM +0100, Harald Arnesen wrote:
>> Fabio Comolli <fabio.comolli@gmail.com> writes:
>>
>> > Still present in -rc5
>
> Help. I've just bisected this down to the same commit
> b56ab33d68638e6aafdbfc694025e8354a628f49 (that will teach me for not
> reading the whole thread) as I have the same problem on my EeePC 900.
>
> Still present in -rc6 and the latest git.
>
> --
> Sitsofe | http://sucs.org/~sits/
>
