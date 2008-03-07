Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYCGG0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYCGG0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbYCGGZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:25:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:12677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760856AbYCGGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=DZIyYrH/NL4YljdzLnC56aDzQVq9D13G1hN+M19qQS2vSzLfdT32zKBQuqRM9MkE9K6U9P/XJlqbNIeyNTVm1FvwpZmYlxtFusfZMVUnyREbieaXApDyp3TyH/eIvH1Y2r+7hr/mTeIflWFsXw6IOMCLWfr09u0U39IbYUKUadc=
Message-ID: <7c86c4470803062225y4727a19ic321314b292dd874@mail.gmail.com>
Date: Thu, 6 Mar 2008 22:25:26 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perfmon x86 infrastructure definitions
Cc: akpm@linux-foundation.org, ak@suse.de,
       "Robert Richter" <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16070_3401877.1204871126067"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16070_3401877.1204871126067
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

adds AMD Northbridge config MSR definition

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>

------=_Part_16070_3401877.1204871126067
Content-Type: application/octet-stream; name=x86-add-nb-cfg-msr.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdid04gq0
Content-Disposition: attachment; filename=x86-add-nb-cfg-msr.diff

LS0tIGEvaW5jbHVkZS9hc20teDg2L21zci1pbmRleC5oCisrKyBiL2luY2x1ZGUvYXNtLXg4Ni9t
c3ItaW5kZXguaApAQCAtODMsNiArODMsNyBAQAogLyogQU1ENjQgTVNScy4gTm90IGNvbXBsZXRl
LiBTZWUgdGhlIGFyY2hpdGVjdHVyZSBtYW51YWwgZm9yIGEgbW9yZQogICAgY29tcGxldGUgbGlz
dC4gKi8KIAorI2RlZmluZSBNU1JfQU1ENjRfTkJfQ0ZHCQkweGMwMDEwMDFmCiAjZGVmaW5lIE1T
Ul9BTUQ2NF9JQlNGRVRDSENUTAkJMHhjMDAxMTAzMAogI2RlZmluZSBNU1JfQU1ENjRfSUJTRkVU
Q0hMSU5BRAkJMHhjMDAxMTAzMQogI2RlZmluZSBNU1JfQU1ENjRfSUJTRkVUQ0hQSFlTQUQJMHhj
MDAxMTAzMgo=
------=_Part_16070_3401877.1204871126067--
