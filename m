Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbYLCJ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbYLCJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYLCJ3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:29:00 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:54517 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYLCJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:28:59 -0500
Date: Wed, 3 Dec 2008 10:28:54 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] hvc_console: fix: hp->ws winsize check runs
	out-of-sync
Message-ID: <20081203092854.GE28137@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linux PPC devel <linuxppc-dev@ozlabs.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Ryan S. Arnold" <rsa@us.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20081118112827.927627788@linux.vnet.ibm.com> <20081118113848.945650506@linux.vnet.ibm.com> <18742.20121.759577.660481@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18742.20121.759577.660481@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Dec 03, 2008 at 08:17:13PM +1100, Paul Mackerras wrote:
> Looks OK.  Is this going to go in via the s390 tree, or should I put
> it in the powerpc tree?
The patch should go via the powerpc tree.

Thanks and regards,
Hendrik
