Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbYCGG0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbYCGG0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762786AbYCGGZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:25:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:12677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762698AbYCGGZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=eNQN8Drbi98shmf+C3aCZ6SDUdREG4J3aFafPpCyYM7jk/+A/OCV13DoPXX4hGU0jhj5WwHgR3zZOYSJSl4FJk0xSyyIbNMUSa/IPBvtmKWJL9syE6QAOFnRzWpuLV3Ol6G17lY2M5tNuAEkryL9m1zoN87WAKUUxoftGRaz+1o=
Message-ID: <7c86c4470803062225j7c9be3aesd7b979ab5617fe5b@mail.gmail.com>
Date: Thu, 6 Mar 2008 22:25:51 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perfmon x86 infrastructure definitions
Cc: akpm@linux-foundation.org, ak@suse.de,
       "Robert Richter" <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16072_10223157.1204871151855"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16072_10223157.1204871151855
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

adds AMD Northbridge PCI Id

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>

------=_Part_16072_10223157.1204871151855
Content-Type: application/octet-stream; name=x86-add-amd-nb-pci-ids.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdid1wma0
Content-Disposition: attachment; filename=x86-add-amd-nb-pci-ids.diff

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGNpX2lkcy5oIGIvaW5jbHVkZS9saW51eC9wY2lf
aWRzLmgKaW5kZXggZWZmZGI1NS4uOTkxNDAwOCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9w
Y2lfaWRzLmgKKysrIGIvaW5jbHVkZS9saW51eC9wY2lfaWRzLmgKQEAgLTQ5Nyw2ICs0OTcsOCBA
QAogI2RlZmluZSBQQ0lfREVWSUNFX0lEX0FNRF9LOF9OQl9BRERSTUFQCTB4MTEwMQogI2RlZmlu
ZSBQQ0lfREVWSUNFX0lEX0FNRF9LOF9OQl9NRU1DVEwJMHgxMTAyCiAjZGVmaW5lIFBDSV9ERVZJ
Q0VfSURfQU1EX0s4X05CX01JU0MJMHgxMTAzCisjZGVmaW5lIFBDSV9ERVZJQ0VfSURfQU1EXzEw
SF9OQgkweDEyMDAKKyNkZWZpbmUgUENJX0RFVklDRV9JRF9BTURfMTBIX05CX01JU0MJMHgxMjAz
CiAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfQU1EX0xBTkNFCQkweDIwMDAKICNkZWZpbmUgUENJX0RF
VklDRV9JRF9BTURfTEFOQ0VfSE9NRQkweDIwMDEKICNkZWZpbmUgUENJX0RFVklDRV9JRF9BTURf
U0NTSQkJMHgyMDIwCgo=
------=_Part_16072_10223157.1204871151855--
