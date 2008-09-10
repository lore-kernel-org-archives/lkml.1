Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYIJOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYIJOsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYIJOsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:48:10 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:10213 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYIJOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:48:09 -0400
X-Greylist: delayed 88962 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2008 10:48:09 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: OOPS: getting an ACPI interrupt while in an ACPI interrupt hangs my box
Date: Wed, 10 Sep 2008 16:47:58 +0200
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200809091605.07734.hs4233@mail.mn-solutions.de> <1221008490.3989.102.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1221008490.3989.102.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101647.58567.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the system is booted with the boot option of
> "processor.max_cstate=1", does the following warning message
> still exist?

Yes, if this did help, then only marginally.
