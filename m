Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbZEATu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbZEATu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZEATuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:50:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZEATuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:50:21 -0400
Date: Fri, 1 May 2009 15:50:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       jistone@redhat.com
Subject: Re: [PATCH] export softirq_to_name symbol
Message-ID: <20090501195015.GA31694@infradead.org>
References: <20090501193022.GB3111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501193022.GB3111@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:30:22PM -0400, Jason Baron wrote:
> 
> hi,
> 
> In response to a user request:
> 
> 
> Export 'softirq_to_name' so that modules using the softirq tracepoints
> can resolve the # to a name.

Please submit it together with the module that uses it.
