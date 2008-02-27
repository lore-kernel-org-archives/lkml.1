Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYB0VeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYB0VeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYB0Vd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:33:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:58465 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYB0Vd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:33:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rSZ43qHZUulcS2X976XKCkwaEZLMG3aG4Alf/JO+oLaue2u7SaWHRC1dC/vahjvCUOFP0jLH/ZotpYcQDswWXktCpBMgNPn9SDQHvXjh/kYl9/PxxAWz5VAmnCCDUmS7yGV5VmjA8byeAnuymp9nG0uFWg9AZUCCqlcle3qwOjs=
Message-ID: <b6c5339f0802271333u3d9ad05dk26b30d59f1b41a75@mail.gmail.com>
Date: Wed, 27 Feb 2008 16:33:54 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [RFC] CodeStyle: Use spaces when aligning/decorating
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, khc@pm.waw.pl,
       bhalevy.lists@gmail.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <47C48FD8.5040205@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204062430.47c488def40a4@portal.student.luth.se>
	 <20080226135444.f83a0536.randy.dunlap@oracle.com>
	 <47C48FD8.5040205@student.ltu.se>
X-Google-Sender-Auth: 382c0b0e3ccbe19f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > FWIW I prefer the {deleted} language.  // PI = 3;
>  >
>  Well, actually I like it too. But I think it should be up to the
>  programmer which setting to use + it seems some people have really taken
>  this to heart, going from 'tab => 8 characters wide' to '8 spaces =>
>  tab', obscuring tab's position as a 'logical indention'.

Well, no one's saying that you can't configure your editor any way you
want.  The tabs=8 is a good cue for the 80-column rule, though.

IMO, CodingStyle used to be a good, funny read and now it's just simply
full of boring pedantic laws.

-Bob
