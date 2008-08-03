Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYHCVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYHCVxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbYHCVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:53:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42291 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYHCVx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:53:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: acpi error on 2.6.27-rc1+ (ACPI Error (dsobject-0501))
Date: Sun, 3 Aug 2008 23:55:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20080803182913.GB8691@joi>
In-Reply-To: <20080803182913.GB8691@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808032355.59016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Probably CC this to linux-acpi as well.]

On Sunday, 3 of August 2008, Marcin Slusarz wrote:
> Hi
> I noticed that 2.6.27-rc1+ (2b12a4c524812fb3f6ee590a02e65b95c8c32229) prints this:
> Completing Region/Field/Buffer/Package initialization:.ACPI Error (dsobject-0501): Package List length (EA) larger than NumElements count (3), truncated
> 
> Is it something to worry about?
> I've put full log, config and acpidump on http://www.kadu.net/~joi/kernel/2008.08.03/
