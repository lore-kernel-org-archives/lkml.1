Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYH0Uir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYH0Uir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYH0Uij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:38:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55343 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYH0Uii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:38:38 -0400
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <20080827203427.GA1158@us.ibm.com>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>
	 <1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu>
	 <1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu>
	 <1219851696.8680.67.camel@nimitz>  <20080827203427.GA1158@us.ibm.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 13:38:30 -0700
Message-Id: <1219869510.8680.90.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 15:34 -0500, Serge E. Hallyn wrote:
> (Or, is that too much effort required on your part to try and
> cherrypick bits of Oren's changes back into your tree?)

That would probably work as long as Oren is working on top of what I
have.  It's going to be a lot harder if I have to repeat the same
break-out process for each iteration of Oren's patches, though.

-- Dave

