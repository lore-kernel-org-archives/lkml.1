Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZABSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZABSMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbZABSMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:12:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37661 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759190AbZABSMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:12:19 -0500
Date: Fri, 2 Jan 2009 18:12:15 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] dm-target: target_type improvements
Message-ID: <20090102181215.GF11060@agk.fab.redhat.com>
Mail-Followup-To: Cheng Renquan <crquan@gmail.com>,
	linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229660385-17153-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 12:19:42PM +0800, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 3. totally remove tt_internal;
> The 3rd patch may be controversial,
> But I still think it's worth it:

Well now that it's down to just one field for linking items I'm inclined to
agree that it's OK.

Do you (or anyone else) have any interest in creating and testing similar sets
of patches for the other parts of device-mapper that use the same construction?

Alasdair
-- 
agk@redhat.com
