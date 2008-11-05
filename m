Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYKEUsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYKEUsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYKEUry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:47:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:30057 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYKEUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q468q/Js5e++aE/0hbPxkyScnJlgYHW+oq4I03ox/n5Iej97vt01i9bAwjcvjkQwcK
         B459MQzaUfgQryz6A23kJZraxGidGRB61fvHGh4sXPNiTiF/pAsq/8QmMtyhCphVzwky
         IjTRINavHzT7zF1W6qCSKJQKJVP+hyJehUw2E=
Message-ID: <9e4733910811051247t1af88c09kb57cb7145816b2ab@mail.gmail.com>
Date: Wed, 5 Nov 2008 15:47:53 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
Subject: Re: [RFC PATCH V4 0/6] In-kernel IR remote control support
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3aaafc130811051215v6a66e9f6n125ffd3727c5a6ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105194640.19407.19682.stgit@localhost>
	 <3aaafc130811051159y1e2fb70fg6b1b915a07daf58e@mail.gmail.com>
	 <9e4733910811051207w4e57086eq3c02f96c9530add6@mail.gmail.com>
	 <3aaafc130811051215v6a66e9f6n125ffd3727c5a6ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 3:15 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> What's involved in converting an LIRC driver into something usable
> with your framework?

Look at either of the two drivers I posted. It is actually very
simple. Drivers just send/receive arrays of pulse timings in
milliseconds.

-- 
Jon Smirl
jonsmirl@gmail.com
