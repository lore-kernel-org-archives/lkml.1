Return-Path: <linux-kernel-owner+w=401wt.eu-S1761556AbYF2Ua1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbYF2Ua1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbYF2UaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:30:11 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:61534 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbYF2UaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xAxh/ag4NXLMCP7K1tDSNkpEVrDTrZkm/yHhuvG/gPxSTMpiF7+r/yDtZVl9VRnUfu
         NbJ9H68QvQTLWLuYWf1+NfHUIa65aHEJaxPPMEsRiKxNpEP3bnRhlSHIqKDWHJBXYfn/
         613fYGrYJgwS3aSC227lS2yFzojficMJqx6IA=
Message-ID: <dd18b0c30806291330w530121a3ka1c9489577957bb6@mail.gmail.com>
Date: Sun, 29 Jun 2008 20:30:09 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <X8mbwW6K81I.A.RPG.j99ZIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.RPG.j99ZIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 6:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (45 days old)
> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>
>
>

yes; still having this message show up. with a patched kernel and
external modules, and with
a fresh kernel with no external modules, or patches.

-- 
Justin P. Mattock
