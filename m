Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZA2Ugm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZA2Ugm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZA2UgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:36:25 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:33071 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZA2UgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YnVh/A9vwspfeOHKyesdAc6qiueNiUXCjmrAkDS403D6FSes8XYfhObVbYDfBapsPw
         r4SPooP6DkKOE5lWKllxCmOi44NlmVSz0HDDouwBggOVKB95Br9IfFxRkEuCDiZFS1rP
         hCAq0UThyOlpc9Nfanbb/8Vo9xBmz3y+H00fo=
MIME-Version: 1.0
In-Reply-To: <87vdryw6ql.fsf@basil.nowhere.org>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
	 <87vdryw6ql.fsf@basil.nowhere.org>
Date: Thu, 29 Jan 2009 12:36:24 -0800
Message-ID: <86802c440901291236k62f2fc21ma08655b4a13f3c4@mail.gmail.com>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old 
	subarchitecture code
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 6:02 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Also bigsmp is kind of obsolete too, it could be probably
> merged with default with very tiny impact because it's not
> all that different.

yes bigsmp should not be treated non-standard.

YH
