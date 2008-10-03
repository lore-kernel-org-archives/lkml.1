Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYJCClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYJCClT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 22:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYJCClK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 22:41:10 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53765 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYJCClJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 22:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p8KvQa6wvgorQhb+uJuooi2Xu1B+gOWEY8XaOmPMRyRx2FfdjdqSMMOL3PbP1ZguDo
         j1YNnsHdFJIod6sWL9N2B+tIZu5xsSPrn+7PdY/r67qcR4vRpIY+PSjdWgc8UBx149mp
         UGPL0CApTyEgAv0JinXZR+cjDn7IjeAYv0i2Y=
Message-ID: <3c1bc2140810021941p5c00acdcs4e3cf10a40c89b7d@mail.gmail.com>
Date: Thu, 2 Oct 2008 21:41:08 -0500
From: "Matthew Stoltenberg" <d3matt@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: motherboard recommendations?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081002162056.GA13007@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1f276abf0809160657x4264ad5dm74fd2689d804a7ad@mail.gmail.com>
	 <20081002143809.GA22851@csclub.uwaterloo.ca>
	 <3c1bc2140810020803l33207ecbsbd690fa33a21a360@mail.gmail.com>
	 <20081002160933.GM22849@csclub.uwaterloo.ca>
	 <20081002162056.GA13007@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 11:20 AM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Oct 02, 2008 at 12:09:33PM -0400,  wrote:
>> Atheros?  Hmm, the P5K was using atlantic, so I wonder why they are not
>> using atheros.
>
> So I am clueless here.  atl is atheros, which is what I have on my
> P5K, except an older model.  I see mentions that 2.6.27 is supposed to
> suport the new chip on the P5Q.

Well... That's what I get for not doing make oldconfig :)  Voila...
It works in rc7.
