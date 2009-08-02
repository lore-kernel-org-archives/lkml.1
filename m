Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZHBWxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZHBWxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZHBWxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:53:30 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:53060 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbZHBWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:53:29 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13865] Can only resume with HP_WMI selected on compaq nc6000 when 4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
Date: Mon, 3 Aug 2009 00:53:26 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "cedric" <cedric@belbone.be>, "Matthew Garrett" <mjg@redhat.com>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <7ixSg7D88bK.A.qOF.3pgdKB@chimera>
In-Reply-To: <7ixSg7D88bK.A.qOF.3pgdKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908030053.27869.elendil@planet.nl>
X-OriginalArrivalTime: 02 Aug 2009 22:53:28.0561 (UTC) FILETIME=[0CF87E10:01CA13C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13865
> Subject	: Can only resume with HP_WMI selected on compaq nc6000 when
>		  4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
> Submitter	: cedric <cedric@belbone.be>
> Date		: 2009-07-29 12:47 (5 days old)

Fix just made it into mainline: daed953721850381673687c59f3a0df553eb6626

Cheers,
FJP
