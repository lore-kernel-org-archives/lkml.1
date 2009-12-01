Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZLALnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZLALnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZLALnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:43:46 -0500
Received: from ns.firmix.at ([62.141.48.66]:1233 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbZLALnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:43:45 -0500
Subject: Re: [BUG] Linux-2.6.32-rc8-git2 Fails To Compile With GCC-4.4.2
From: Bernd Petrovitsch <bernd@firmix.at>
To: Tarkan Erimer <tarkane@netone.com.tr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B15006C.2020207@netone.com.tr>
References: <4B14FB56.4040608@netone.com.tr>
	 <1259666631.23038.7.camel@tara.firmix.at>  <4B15006C.2020207@netone.com.tr>
Content-Type: text/plain; charset="UTF-8"
Organization: Firmix Software GmbH
Date: Tue, 01 Dec 2009 12:43:43 +0100
Message-Id: <1259667823.23038.9.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.287 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.287 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 01 Dec 2009 12:43:51 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 13:39 +0200, Tarkan Erimer wrote:
> On 12/01/2009 01:23 PM, Bernd Petrovitsch wrote:
> > On Tue, 2009-12-01 at 13:17 +0200, Tarkan Erimer wrote:
> >> I wanted to compile linux-2.6.32-rc8-git2 with gcc-4.2.2 on opensuse
> >> 11.2. But, it failed with the following error :
> >>
> >> PS: When I googled, I found the same error on Ubuntu Lucid forums with
> >> gcc-4.4.2, too.
> > [...]
> >   
> >> CC kernel/audit_tree.o
> >> kernel/audit_tree.c: In function ‘find_chunk’:
> >> kernel/audit_tree.c:206: internal compiler error: Segmentation fault
> >> Please submit a full bug report,
> >> with preprocessed source if appropriate.
> >>     
> > That's a clear gcc bug. So please throw it in their bugzilla (or whatever they hav).
> >   
> OK, I will. Thanks for pointing.
Just to make sure: I meant OpenSUSEs bug tracker since you produced the
error with OpenSUSEs gcc.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


