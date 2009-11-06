Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbZKFVj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbZKFVj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZKFVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:39:28 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:57740 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZKFVj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:39:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uW2PF47Eh5M1EpUo4uwJQp08HbbxH+wrnz+HIzs3KELwsP3ZvhE2w1pqKkmze1TWmn
         N4apGjfxO94NHcmWN21FZ3fj6ju+h7rEl11QBn1SvxrlO3AgQh/KRBmJBEU+NzSzMp8O
         AYdSzF9vrXIWJeAwQRvu8cTXhofCfDk3+BjSY=
MIME-Version: 1.0
In-Reply-To: <87iqdn76jg.fsf@basil.nowhere.org>
References: <1257167821.4977.41.camel@subratamodak.linux.ibm.com>
	 <87iqdn76jg.fsf@basil.nowhere.org>
Date: Fri, 6 Nov 2009 13:39:32 -0800
Message-ID: <364299f40911061339x7b689d3cw705674bd9b332e5c@mail.gmail.com>
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been Released for 
	OCTOBER 2009
From: Garrett Cooper <yanegomi@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: subrata@linux.vnet.ibm.com, ltp-list <ltp-list@lists.sf.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 12:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Subrata Modak <subrata@linux.vnet.ibm.com> writes:
>>
>> ========================
>> OCTOBER 2009 Highlights:
>
> s/High/Low/
>
>> ========================
>>      1. LTP Makefiles rewrite:(Project started 1.2 years back)
>>              I. To accommodate correct build/installation practices,
>>             II. better integrate Autoconf/Automake with tests for safer
>>                 builds,
>>            III. better cross-compilation of LTP sources.
>
> Just as a warning for everyone: that change broke building on most old
> distributions and there seems to be no interest in fixing that.
>
> Unless you're running the latest and greatest better stay with older LTP
> versions.

Andi,
    Let's keep this discussion on track with the other thread that's
open. We can probably come to an engineering solution that will allow
your version of make (3.80) to function, but I think that a line needs
to be drawn in the sand at that version because make 3.79 is too
ancient (~7 years old) to work with.
Thanks,
-Garrett
