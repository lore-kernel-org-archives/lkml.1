Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZCCQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZCCQtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCCQtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:49:05 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55318 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752650AbZCCQtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:49:04 -0500
Date: Tue, 3 Mar 2009 11:36:35 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] cpusets: replace zone allowed functions with node
 allowed
In-Reply-To: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903031136030.26454@qirst.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, David Rientjes wrote:

> The cpuset_zone_allowed() variants are actually only a function of the
> zone's node.

Good observation.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

