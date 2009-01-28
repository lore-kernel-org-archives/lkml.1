Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZA1Dot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZA1Dot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZA1Dol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:44:41 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:21716 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZA1Dok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:44:40 -0500
Date: Tue, 27 Jan 2009 19:44:07 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: Make lockdep happy with configfs
Message-ID: <20090128034407.GD7244@mail.oracle.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <20081218111536.GR19128@hawkmoon.kerlabs.com> <1229623218-8056-1-git-send-email-louis.rilling@kerlabs.com> <20090126115151.GC7532@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126115151.GC7532@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.497FD489.00DA:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 12:51:52PM +0100, Louis Rilling wrote:
> Are you going to take one of these approaches to make lockdep and configfs
> cohabit?

	I'm going to look at your patches now and do some review - sorry
it took me so long.
	I do think our discussion with Peter elsewhere may have even
better fruit, so I'm going to hold of on including these just yet.

Joel


-- 

Life's Little Instruction Book #510

	"Count your blessings."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
