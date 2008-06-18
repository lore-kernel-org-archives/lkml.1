Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYFRJ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYFRJ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYFRJ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:58:37 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:54967 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYFRJ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:58:35 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Nikola Ciprich <extmaillist@linuxbox.cz>,
       Jesse <jesse.brandeburg@intel.com>
Subject: Re: [regression?] e1000e breaks IPMI
Date: Wed, 18 Jun 2008 11:58:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181158.34412.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I hate working around this broken BMC (again) when others are known to
> work just fine, and CRC stripping in hardware really simplifies our
> receive path.

Due to rather bad experiences I'm always alarmed about IPMI problems (actually 
so far not with supermicro, but with other vendors). So I contacted 
supermicro and immediately got an answer they have a new LAP EEPROM to fix 
this problem. 

So the problem with supermicro is solved, lets see what the other vendor, I 
also contacted, says.



-- 
Bernd Schubert
Q-Leap Networks GmbH
