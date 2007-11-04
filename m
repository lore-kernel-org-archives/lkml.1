Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXKDXoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXKDXoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbXKDXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:43:58 -0500
Received: from ns.firmix.at ([62.141.48.66]:1651 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbXKDXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:43:57 -0500
Subject: Re: duplicated include files
From: Bernd Petrovitsch <bernd@firmix.at>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Marco Costalba <mcostalba@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711041447330.6072@localhost.localdomain>
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
	 <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
	 <Pine.LNX.4.64.0711041447330.6072@localhost.localdomain>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 05 Nov 2007 00:43:52 +0100
Message-Id: <1194219832.12714.12.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.314 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.314 required=5
X-Spam-Score: -2.314 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-11-04 at 14:49 -0500, Robert P. J. Day wrote:
[...]
> actually, one wonders if there's any value in keeping any references
> to other version control systems such as subversion, SCCS, CVS,
> mercurial, etc.

Lots of people have their working trees in CVS, Subversion, ....
So it probably annoys them and doesn't really buy anything IMHO.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

