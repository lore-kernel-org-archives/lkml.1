Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZCVP4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZCVP4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 11:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZCVP4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 11:56:43 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:41824 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZCVP4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 11:56:43 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Date: Sun, 22 Mar 2009 16:56:20 +0100
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200903042020.57671.eike-kernel@sf-tec.de> <200903081902.23998.eike-kernel@sf-tec.de> <20090314133704.GA21948@silver.sucs.org>
In-Reply-To: <20090314133704.GA21948@silver.sucs.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13171815.bbqSa3piNE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903221656.28973.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13171815.bbqSa3piNE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sitsofe Wheeler wrote:
> On Sun, Mar 08, 2009 at 07:02:17PM +0100, Rolf Eike Beer wrote:
> > Sitsofe Wheeler wrote:
> > > On Wed, Mar 04, 2009 at 08:20:56PM +0100, Rolf Eike Beer wrote:
> > > > I tested several snapshots post 2.6.28 and all of them show one
> > > > severe problem: resume from disk is not always successful. Only about
> > > > 50% of the resume attempts work, in the other cases I just get a
> > > > completely black screen, can't switch to text console or anything.
> > > > What I often get is a line like this in the logs directly before
> > > > suspend:
> > >
> > > Does this happen when X hasn't been started and you suspend to disk
> > > then resume?
> >
> > I tested several times without X, with X running only in backgroud (i.e.
> > me initiating the suspend from console) and from xdm only. Never it
> > froze. That leads me to the conclusion that it is probably related to
> > composite. I'm
>
> Hmm. Does switching to and then back from a virtual terminal also break?

Nope, works fine (testing current git).

Eike

--nextPart13171815.bbqSa3piNE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAknGX6wACgkQXKSJPmm5/E41CQCeIwuuCwSwkNa0J7x1EJWtbYB1
WLwAnjiJMftJgm51WzVxa+Uo6WIYpp+R
=LXa3
-----END PGP SIGNATURE-----

--nextPart13171815.bbqSa3piNE--
