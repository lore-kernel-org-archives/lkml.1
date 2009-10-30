Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZJ3SR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZJ3SR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932813AbZJ3SRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:17:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50916 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932721AbZJ3SRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:17:14 -0400
Date: Fri, 30 Oct 2009 14:10:52 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/7] m68knommu: Split the .init section into
 INIT_TEXT_SECTION and INIT_DATA_SECTION.
In-Reply-To: <20091030113512.GB26667@merkur.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0910301410130.30680@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-7-git-send-email-tabbott@ksplice.com> <4AEA3DC9.7080205@snapgear.com> <alpine.DEB.1.10.0910292116511.24830@dr-wily.mit.edu> <20091030113512.GB26667@merkur.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Sam Ravnborg wrote:

> Let's postpone this fix until merge window opens.
> I doubt it has any real effect anyway.

OK, seems reasonable.

	-Tim Abbott
