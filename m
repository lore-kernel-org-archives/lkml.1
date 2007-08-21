Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbXHUED6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbXHUED6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXHUEDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:03:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:33385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbXHUEDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:03:48 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Arkadiusz Miskiewicz <arekm@maven.pl>, shaohua.li@intel.com
Subject: Re: resume from ram much slower
Date: Tue, 21 Aug 2007 00:03:34 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200708101848.37222.arekm@maven.pl>
In-Reply-To: <200708101848.37222.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708210003.34481.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Starting 1-2 weeks ago I have very long resume from
> ram times. It takes more than 1 min to resume.

Do you see any difference with "pnpacpi=off"?

thanks,
-Len


