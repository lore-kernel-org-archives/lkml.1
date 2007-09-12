Return-Path: <linux-kernel-owner+w=401wt.eu-S970841AbXILRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970841AbXILRLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765588AbXILRLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:11:32 -0400
Received: from ns.firmix.at ([62.141.48.66]:60622 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965599AbXILRLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:11:31 -0400
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070912170529.GA18311@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
	 <20070912170529.GA18311@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 12 Sep 2007 19:11:21 +0200
Message-Id: <1189617081.31502.78.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.315 required=5
X-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 19:05 +0200, Sam Ravnborg wrote:
[....]
> Being rpm ignorant I do not know what the expected content of a kernel-source RPM
> are but this is the available targets for kernel packaging (from make help):

The kernel-source including all patches and configured as usually to be
found under
/usr/src/linux-$VERSION (or so). One needs that for e.g. external
modules.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


