Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZEOTkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZEOTkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZEOTk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:40:29 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2208 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZEOTk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:40:28 -0400
Subject: Re: [PATCH 11/11] mm: Convert #ifdef DEBUG printk(KERN_DEBUG to
 pr_debug(
From: Joe Perches <joe@perches.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, David Rientjes <rientjes@google.com>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090515185602.GA28604@us.ibm.com>
References: <cover.1242407227.git.joe@perches.com>
	 <d2d789905b3ec219d015729a162be7707564fb67.1242407227.git.joe@perches.com>
	 <20090515185602.GA28604@us.ibm.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 12:40:25 -0700
Message-Id: <1242416425.3373.50.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 13:56 -0500, Serge E. Hallyn wrote:
> Seems reasonable - apart from my woes with dynamic_printk :)

pr_devel instead?


