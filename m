Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZIJVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZIJVoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZIJVoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:44:05 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:59328 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752376AbZIJVoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:44:05 -0400
Date: Thu, 10 Sep 2009 17:42:46 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jeff Layton <jlayton@redhat.com>
cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
In-Reply-To: <20090910165757.43b77874@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.1.10.0909101742190.9964@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1> <20090905071052.50501826@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1> <20090909125352.1c7b57d2@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
 <20090909132039.1ca47cd4@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1> <20090909140257.35ede0cc@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1> <20090909205548.4858b524@zanovar.poochiereds.net>
 <alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1> <20090910153347.2f2616e8@barsoom.rdu.redhat.com> <alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1> <20090910165757.43b77874@tlielax.poochiereds.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One other issue that may be important: The mounting operation is very slow
on 32 bit. Could it be that the handshake does not work out?


