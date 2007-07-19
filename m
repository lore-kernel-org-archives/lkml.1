Return-Path: <linux-kernel-owner+w=401wt.eu-S965248AbXGSOMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbXGSOMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938608AbXGSN66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:58:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44185 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938334AbXGSN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:58:55 -0400
Date: Thu, 19 Jul 2007 14:58:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: Jim Kovaric <jkovaric@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, serue@linux.vnet.ibm.com
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719135844.GB16279@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	James Morris <jmorris@namei.org>, Jim Kovaric <jkovaric@us.ibm.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Stephen Smalley <sds@tycho.nsa.gov>, serue@linux.vnet.ibm.com
References: <OF54A17BCF.9A1D7004-ON8725731D.0044828E-8625731D.0046CAED@us.ibm.com> <Line.LNX.4.64.0707190901200.4393@d.namei> <Line.LNX.4.64.0707190912520.4393@d.namei>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707190912520.4393@d.namei>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 09:19:56AM -0400, James Morris wrote:
> Is my understanding correct?
> 
> You're shipping this to customers as a security feature?

It's the usual Tivoli crap, what would you expect?

