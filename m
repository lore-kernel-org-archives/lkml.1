Return-Path: <linux-kernel-owner+w=401wt.eu-S935404AbXKPVqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404AbXKPVqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935097AbXKPVnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:43:32 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:48617 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935074AbXKPVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:43:29 -0500
X-YMail-OSG: 3oDnVRoVM1ktgIC6r4WPgaJ4t6NBY7SaxXbqZOGW4HIaZJylbBf2Le4U3WIUlywvTuhF7l8yTQ--
Date: Fri, 16 Nov 2007 13:43:27 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071116214327.GA9685@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de> <20071116003410.GA16797@puku.stupidest.org> <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org> <20071116110315.GA27969@puku.stupidest.org> <1195222772.7653.16.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195222772.7653.16.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 09:19:32AM -0500, Trond Myklebust wrote:

> Very funny, but disabling XFS on the client won't help.

Oops, I meant it for NFSD...  and I'm somewhat serious.  I'm not
saying it's a good long term solution, but a potentially safer
short-term workaround.

