Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbYBFWkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbYBFWkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYBFWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:40:48 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:5012 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbYBFWkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VdmNwjTP07IQwYNKP5NCPaVrr9IvlCphHYS1i1TIwWnLl88mOBLeZ3q4zF8aGi4dIHAtA45PNidLGFmEq8lbJoqVNUFtjLdKuPW9g8ggISlA1OiC0tTmB6MqN+z6ocq+8+BvlPyBR/1EXEs+Mj6FeBAYlQfYC/IIupwF5VP0Cq8=
Message-ID: <31e679430802061440r10046663m17ef3f9d6f57806e@mail.gmail.com>
Date: Wed, 6 Feb 2008 17:40:41 -0500
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: ggriffin10 <ggriffin10-nab@yahoo.com>
Subject: Re: T61P sound issue
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <15316561.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
	 <20080204194038.d8851b8d.akpm@linux-foundation.org>
	 <15316561.post@talk.nabble.com>
X-Google-Sender-Auth: f4a76a924f6a887a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 6, 2008 5:33 PM, ggriffin10 <ggriffin10-nab@yahoo.com> wrote:
>
> > ooh, a fellow t61p owner.  How's suspend and resume working?
> I spent days getting it to work. I'm not an expert and don't know if made
> any poor decisions, I tested suspend to ram in a bunch of configurations and
> finally got it to work consistently. I think I have to restart the network
> after resume, but I'm okay with that. Some things that may be of interest:

suspend to ram is working perfectly here:
s2ram -f -a 3

suspend to disk is perfect just issuing:
s2disk

;-)

PS: Stupid laptop, it works differently for everybody in this list :-p

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
