Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYCQNPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYCQNPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYCQNPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:15:25 -0400
Received: from mail.fieldses.org ([66.93.2.214]:37916 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbYCQNPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:15:24 -0400
Date: Mon, 17 Mar 2008 09:15:21 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080317131521.GA13177@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz> <20080314181413.GF2119@fieldses.org> <20080314193350.GK2119@fieldses.org> <20080314195303.GA4390@ics.muni.cz> <20080314200510.GL2119@fieldses.org> <20080317081259.GA13095@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317081259.GA13095@ics.muni.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 09:12:59AM +0100, Lukas Hejtmanek wrote:
> Hello,
> 
> On Fri, Mar 14, 2008 at 04:05:10PM -0400, J. Bruce Fields wrote:
> > That said, I'd definitely still appreciate your confirmation that this
> > fixes your bug, so thanks for offering to retest that Monday.
> 
> seems to be OK even from the insecure port. Thanks.

Thanks for the confirmation.--b.
