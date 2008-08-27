Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYH0J73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYH0J73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYH0J7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:59:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39263 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYH0J7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:59:20 -0400
Date: Wed, 27 Aug 2008 12:01:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, jassi brar <jassi_singh_brar@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
Message-ID: <20080827100147.GS26610@one.firstfloor.org>
References: <87tzd89oap.fsf@basil.nowhere.org> <348573.4171.qm@web33204.mail.mud.yahoo.com> <20080827074751.GO26610@one.firstfloor.org> <48B52506.6060205@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B52506.6060205@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 07:27:26PM +0930, David Newall wrote:
> Andi Kleen wrote:
> > I fail to see what your patch generalizes? AFAIK it just adds a new
> > more narrow (less features than the old one) interface to create loop devices.
> >   
> 
> AFAYK it adds at least one new feature: partition tables.

kpartx does those for loop devices already.

-Andi

-- 
ak@linux.intel.com
