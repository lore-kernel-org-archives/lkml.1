Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZJXSFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZJXSFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 14:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZJXSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 14:05:18 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:50651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZJXSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 14:05:17 -0400
Subject: Re: 2.6.32-rc5-git3 -- EIP is at cfg80211_conn_work+0x73/0xd6
 [cfg80211]
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4AE2683D.4020000@gmail.com>
References: <4AE2683D.4020000@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZZOqihymNpO7mnTifU5c"
Date: Sat, 24 Oct 2009 20:05:19 +0200
Message-Id: <1256407519.12174.502.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZZOqihymNpO7mnTifU5c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-23 at 22:36 -0400, Miles Lane wrote:

> EIP is at cfg80211_conn_work+0x73/0xd6 [cfg80211]

That's strange. What actually happened here? NULL ptr deref?

johannes

--=-ZZOqihymNpO7mnTifU5c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK40HYAAoJEODzc/N7+Qma5P4P/jg8tR/Sq8SK1P4yDdT6cBrA
vlDaGV+L+kHcQ0ADjlW/t/4XRCN/eIz2soOtwlGNvXE6k4gwIhEeANMxTqF74I49
bH0FpY+VHpDopwML8qV45kRTb52wy6c98WH+KTpXhMAXZqaaUVqWZ0k0cNfL+m/I
K48YREIFo8hh4J3qJT3zDjs8HjbzHZvVFVYT1WfP5hNEtzenyI5e4ZxWLuiWBwQB
BGZihzDOjPjdGflDGMNXdwz3TwT4oL1iFv4DdLuXw0BiqgV0vYfYg1/+oDyR19ND
VDT8YmEN9DRbT+YPSzy86sv2Bl9h1gFok37S8+B9MJ7FFw4zaUiYCBfy2ra9zd8D
E/DjkuMiXeRS+2aGBBibvgWvdeZRJjduVqMnb1zqMsw/Kqn2x3hMV60LeQy+2nUC
qaKQrTKPzUoY3YzKAWSVhYdbHSHWaCIRKbUXQfFgHRkZEk7gwel8AFmTQcbxC8tN
+Zwo2vvc6nwWqwVTvX1bfzqYUBAiQeLDE7t6Rc6hFN44u6R1JncN9l0ZmfTGLHwX
H+aMuwG7povA4SDVsdWDrqo7CkLkZaVpTbaxBOpwT8w7kdzC0cM9vfbn/f8Q8gCG
zwtHXtr4SShtAwnghocV9iLk+mZoJZQnvlxN0r6oB5aG97GVxlKWF46j0l3gDhav
PqOec63UQbmccUYFXkbC
=KYM8
-----END PGP SIGNATURE-----

--=-ZZOqihymNpO7mnTifU5c--

