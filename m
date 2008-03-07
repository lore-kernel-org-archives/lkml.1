Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbYCGGZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbYCGGZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbYCGGZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:25:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:12677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702AbYCGGZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:25:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=aYOLti9IvR6P5LkQbsC15ICQmZrTdX7c7vK2e5yqX9SxpmNtO20FZxpGGFJpriLWDBGMgfDPsMEl52vuNludakXA080BRJpYGUI5vgsNxHSZ+91Iejg1KB019x8ZJ8UVJlmqqLi/IA3YTw4bXQMmz7ZJOULAKtImT8TgjEbEsvo=
Message-ID: <7c86c4470803062225t65226294rc62fd7b67edab21c@mail.gmail.com>
Date: Thu, 6 Mar 2008 22:25:12 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perfmon x86 infrastructure definitions
Cc: akpm@linux-foundation.org, ak@suse.de,
       "Robert Richter" <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16068_9248518.1204871112688"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16068_9248518.1204871112688
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

adds cpu_has_arch_perfmon to test presence of architectural perfmon on
Intel x86 processor

Signed-off-by: Stephane Eranian <eranian@gmail.com>

------=_Part_16068_9248518.1204871112688
Content-Type: application/octet-stream;
 name=x86-add-perfmon-cpufeature.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdicy4nk0
Content-Disposition: attachment; filename=x86-add-perfmon-cpufeature.diff

LS0tIGEvaW5jbHVkZS9hc20teDg2L2NwdWZlYXR1cmUuaAorKysgYi9pbmNsdWRlL2FzbS14ODYv
Y3B1ZmVhdHVyZS5oCkBAIC0xODEsNiArMTgxLDcgQEAgZXh0ZXJuIGNvbnN0IGNoYXIgKiBjb25z
dCB4ODZfcG93ZXJfZmxhZ3NbMzJdOwogI2RlZmluZSBjcHVfaGFzX2NsZmx1c2gJCWJvb3RfY3B1
X2hhcyhYODZfRkVBVFVSRV9DTEZMU0gpCiAjZGVmaW5lIGNwdV9oYXNfYnRzCQlib290X2NwdV9o
YXMoWDg2X0ZFQVRVUkVfQlRTKQogI2RlZmluZSBjcHVfaGFzX2dicGFnZXMJCWJvb3RfY3B1X2hh
cyhYODZfRkVBVFVSRV9HQlBBR0VTKQorI2RlZmluZSBjcHVfaGFzX2FyY2hfcGVyZm1vbiAJYm9v
dF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0FSQ0hfUEVSRk1PTikKIAogI2lmIGRlZmluZWQoQ09ORklH
X1g4Nl9JTlZMUEcpIHx8IGRlZmluZWQoQ09ORklHX1g4Nl82NCkKICMgZGVmaW5lIGNwdV9oYXNf
aW52bHBnCQkxCg==
------=_Part_16068_9248518.1204871112688--
