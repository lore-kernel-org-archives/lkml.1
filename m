Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXCLQhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXCLQhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXCLQhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:37:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:29286 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXCLQhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fi9ixEeS4ExvFOTwN83ss8X9VdaRzEGKm6uR9blnlmD/5GRr/jIzxCw9/5Rpo4UCvubRSUgpgfrLQpvTzFifcCURlkrQTLxuBFkDp2NPYteo2xZR0oYvWSu2E49pfv3iYvtfHowkDlecxeSMPuUNNyOORJk0j74QBAoEyQEeaNo=
Message-ID: <b14e81f00703120937o5c1baa39n582d57d9208ae459@mail.gmail.com>
Date: Mon, 12 Mar 2007 12:37:19 -0400
From: "michael chang" <thenewme91@gmail.com>
To: "jos poortvliet" <jos@mijnkamer.nl>
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Cc: ck@vds.kolivas.org, "Al Boldi" <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703121559.23157.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703122352.51257.kernel@kolivas.org>
	 <200703121714.25034.a1426z@gawab.com>
	 <200703121559.23157.jos@mijnkamer.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, jos poortvliet <jos@mijnkamer.nl> wrote:
> Op Monday 12 March 2007, schreef Al Boldi:
> >
> > It only takes one negatively nice'd proc to affect X adversely.
>
> goes faster than ever)? Or is this really the scheduler's fault?
>

Take this with a grain of salt, but, I don't think this is the
scheduler's _fault_. That said, if the scheduler can fix it, it's not
necessarily a bad thing.

-- 
~Mike
 - Just the crazy copy cat.
