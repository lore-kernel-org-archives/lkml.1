Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXLRSJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXLRSJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXLRSJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:09:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:42531 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXLRSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JlwBQiDh0BixWqkg6jixBxbh3W1fRP79qvexZp4mZ+y9mBESfkFIW8bf7AQL5bWe6YAiaIEXzUVsgDWe/fLtty4QnT6zWfmkTzfY81IG6+1RafBy0FM8DZxw77u8WgCIAEuGkmkL40KqXZEkvQJUQNww01nP9vJVskOe71uVaqU=
Message-ID: <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
Date: Tue, 18 Dec 2007 13:09:30 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com>
	 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com>
	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Well you could still blame Java. I am sure that if you program was C,
> >> the problem could be narrowed down much easier.
> >
> >That may very well be true, but I can't rewrite the whole 500K line
> >application in C at this point.  Plus, it's a web app which would be
> >"fun" to implement in C.
>
> Well I do not require you to do /that/, but you could try adhering to
> the unix philosophy later on that one program should do (ideally) one
> thing, and if the java blob already serves the webpage, then opening
> sockets and doing xyz could probably live in another program.

Fair enough.  So if the application was written in C, how would that
make this problem any easier to narrow down?
