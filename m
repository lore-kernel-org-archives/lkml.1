Return-Path: <linux-kernel-owner+w=401wt.eu-S1764647AbXHVSIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764647AbXHVSIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763159AbXHVSIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:08:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:24615 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763120AbXHVSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BqoBVG6x+R8lBYa4ntSqlER225xHdz3/iJoaoOWF3viuKjvvsJ2m8mrT2BaIdb8VG49+3as0smAJcpo7Eu19ViRd68vPvI+TBXyRZlrri923Qoc8QSR3Mu+Oobm3Y2R3jUsaGixlU7UIzFRQfavErfK8oO67GAEUaYZ9yfRmDAU=
Message-ID: <6bffcb0e0708221108q7e4db8e6sba5e3845ccc0a9aa@mail.gmail.com>
Date: Wed, 22 Aug 2007 20:08:32 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Cc: "Stephen Smalley" <sds@tycho.nsa.gov>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <Xine.LNX.4.64.0708221038030.5819@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822083844.%N@1wt.eu>
	 <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
	 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
	 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
	 <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au>
	 <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com>
	 <Xine.LNX.4.64.0708221038030.5819@us.intercode.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/07, James Morris <jmorris@namei.org> wrote:
> On Wed, 22 Aug 2007, Michal Piotrowski wrote:
>
> > Yup, it is very interesting why no one noticed it.
>
> The new network controls are not enabled by default yet in distros.

That's why I enable most of these unsupported features :)

Unfortunately, I don't have time to test all stable/development releases.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
