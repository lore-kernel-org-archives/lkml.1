Return-Path: <linux-kernel-owner+w=401wt.eu-S1946403AbXBQEDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946403AbXBQEDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 23:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946404AbXBQEDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 23:03:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:21722 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946403AbXBQEDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 23:03:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LwgrauQVlTQP/1wTK66UAhDHMA6Cmi+auIYhMSmLvZHJztZh2uAwMAqOfSbG28xA2X88R9zaN+Fb3JdLRaF0Ul3V1ZT5w1zhyMMci4K7a5mso9J0I6npfw9N1RLNzFrZcPDzZYULo7Iqc9N0t/0dqb1XKWwSA/mQo6Qr2+RLXUA=
Message-ID: <f2b55d220702162003kbc7a16dxca4d97252e6f2050@mail.gmail.com>
Date: Fri, 16 Feb 2007 20:03:16 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: GPL vs non-GPL device drivers
Cc: linux-kernel@vger.kernel.org, "v j" <vj.linux@gmail.com>,
       "Theodore Tso" <tytso@mit.edu>, "Dave Jones" <davej@redhat.com>
In-Reply-To: <200702151742.15850.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <200702151742.15850.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Gene Heskett <gene.heskett@verizon.net> wrote:
[ignorant silliness]
> There is no one to my knowledge here, who would not cheer loudly once a
> verdict was rendered because that courts decision would give the FOSS
> community a quotable case law as to exactly what is, and is not legal for
> you to do with GPL'd code.  We would after 16+ years of the GPL, finally
> have a firm, well defined line drawn in the sand, a precedence in US case
> law that at present, only exists in Germany.

Oferchrissake.  We do have a US precedent, insofar as a decision in a
court of fact on issues of fact can ever be a precedent in a common
law system (hint: zero, unless the later judge feels like quoting some
compelling prose).  That would be Progress Software v. MySQL (also
known as MySQL v. NuSphere in some commentators' writings).  The FSF
interpretation of the GPL lost.  Completely.  Which is true also of
the Munich and Frankfurt decisions.

The plaintiffs, as authors of GPL works, got a full hearing in each
case -- via routine reasoning about the GPL as an offer of contract,
whose conditions either had (Progress Software) or had not
(Fortinet/Sitecom and D-Link) been performed to the extent necessary
for the defendant to claim license under the GPL.  MySQL did obtain a
preliminary injunction, but on unrelated trademark license grounds;
the GPL claim got them nowhere, for at least four distinct reasons
stated in the opinion.  Harald's recovery was limited to statutory
costs and, in the Munich case, an injunction to _either_ offer the
source code of netfilter/iptables itself _or_ stop shipping product.
Both German courts refused to find contract "in personam" (necessary
to a breach of contract claim, in turn necessary to a demand for
specific performance).

"GPL is a creature of copyright law" lost in court, every time.
"Section 4 is a limitation of scope, not a conditional performance"
lost.  "You can lose your license irrevocably" lost.  "We can compel
disclosure of source code with no alternative" lost.  "We can
circumvent contract law standards of breach and remedy" lost.
Everything RMS and Eben Moglen have ever written about the legal
meaning of the GPL is wrong, and where "derivative works" are
concerned, embarrassingly hypocritical as well.  Take the Big Lie
elsewhere, please!

- Michael
