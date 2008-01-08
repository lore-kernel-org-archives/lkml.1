Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYAHW2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYAHW2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYAHW2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:28:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54897 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025AbYAHW2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:28:09 -0500
Date: Tue, 8 Jan 2008 14:28:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 08/19] add newly swapped in pages to the inactive list
In-Reply-To: <20080108210006.795597166@redhat.com>
Message-ID: <Pine.LNX.4.64.0801081427270.4678@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com> <20080108210006.795597166@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rik van Riel wrote:

> In short, this patch needs testing.

Seems to be a good idea.

Reviewed-by: Christoph Lameter <clameter@sgi.com>
