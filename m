Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZEPVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZEPVLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 17:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZEPVLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 17:11:09 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:12804 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZEPVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 17:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VqzhImEYDIDrLMIIlRYs3/QNJ70iio3EcYoKULd2E46hJsILMdszcIW5h21wSwFa8X
         Z3NcvmU1SeI2+Kkf0JvLv2WzqsFngqFlRRwVuXjp0S6b/PkOnaPJLJimgoIh2sXlvqt6
         u711na1TDA3DekyJ3KXubyXm9vSYJ4CuTCgAw=
MIME-Version: 1.0
In-Reply-To: <93655eb70905152352n6f82ef9dubb9b36e5be161ac7@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>
	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>
	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>
	 <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>
	 <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
	 <93655eb70905152012j2a40d2e0ta413a5e9dee34d46@mail.gmail.com>
	 <5bdc1c8b0905152037r614eaf8ft222c7a6294f2e80f@mail.gmail.com>
	 <93655eb70905152352n6f82ef9dubb9b36e5be161ac7@mail.gmail.com>
Date: Sat, 16 May 2009 14:11:08 -0700
Message-ID: <5bdc1c8b0905161411j2afe38fcpbb38730631fac2c3@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Mark Knecht <markknecht@gmail.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 11:52 PM, Satish Eerpini <eerpini@gmail.com> wrote:
>> Do you believe this was working better on an earlier kernel? If so you
>> might drop back and see if these commands work better. If so that
>> would suggest a regression of some type.
>
> I remember good performance with 2.6.26.x series, ... but I could not
> try that out, ,... things on a 2.6.27.23 kernel seem no better :
>

I think it's critically important that you find a kernel that has good
performance. Without it we're trusting a memory. With it developers
can bisect and find the solution.

- Mark
