Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYGVMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYGVMg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYGVMgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:36:49 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:53359 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbYGVMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:36:48 -0400
X-Greylist: delayed 3543 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 08:36:47 EDT
Subject: pro_arm_davinci_watchdog_fix.patch
From: Egorov Evgeny <eegorov@ru.mvista.com>
Reply-To: eegorov@ru.mvista.com
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-A2HJGaIfb/Z78I7wTL+8"
Date: Tue, 22 Jul 2008 15:36:39 +0400
Message-Id: <1216726599.3538.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-10.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A2HJGaIfb/Z78I7wTL+8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch fix bug of watchdog driver's write fuction which allow to
prevent wdt timeout.  

--=-A2HJGaIfb/Z78I7wTL+8
Content-Disposition: attachment; filename=pro_arm_davinci_watchdog_fix.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=pro_arm_davinci_watchdog_fix.patch; charset=UTF-8

U291cmNlOiBNb250YVZpc3RhIFNvZnR3YXJlLCBJbmMuIA0KTVI6MjY4MzMgDQpUeXBlOiBGaXgg
QnVnIA0KRGlzcG9zaXRpb246IFN1Ym1pdHRlZCB0byBXaW0gdmFuIFNlYnJvZWsNClNpZ25lZC1v
ZmYtYnk6IEVnb3JvdiBFdmdlbnkgPGVlZ29yb3ZAcnUubXZpc3RhLmNvbT4NCkRlc2NyaXB0aW9u
Og0KICAgIFRoaXMgcGF0Y2ggZml4IGJ1ZyBvZiB3YXRjaGRvZyBkcml2ZXIncyB3cml0ZSBmdWN0
aW9uDQogICAgd2hpY2ggYWxsb3cgdG8gcHJldmVudCB3ZHQgdGltZW91dC4gDQoNCkluZGV4OiBs
aW51eC0yLjYuMTgvZHJpdmVycy9jaGFyL3dhdGNoZG9nL2RhdmluY2lfd2R0LmMNCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCi0tLSBsaW51eC0yLjYuMTgub3JpZy9kcml2ZXJzL2NoYXIvd2F0Y2hkb2cvZGF2aW5jaV93
ZHQuYw0KKysrIGxpbnV4LTIuNi4xOC9kcml2ZXJzL2NoYXIvd2F0Y2hkb2cvZGF2aW5jaV93ZHQu
Yw0KQEAgLTEzMywxMyArMTMzLDggQEAgc3RhdGljIHNzaXplX3QNCiBkYXZpbmNpX3dkdF93cml0
ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgY29uc3QgY2hhciAqZGF0YSwgc2l6ZV90IGxlbiwNCiAJCSAg
bG9mZl90ICpwcG9zKQ0KIHsNCi0JLyogIENhbid0IHNlZWsgKHB3cml0ZSkgb24gdGhpcyBkZXZp
Y2UgICovDQotCWlmIChwcG9zICE9ICZmaWxlLT5mX3BvcykNCi0JCXJldHVybiAtRVNQSVBFOw0K
LQ0KIAlpZiAobGVuKQ0KIAkJd2R0X3NlcnZpY2UoKTsNCi0NCiAJcmV0dXJuIGxlbjsNCiB9DQog
DQo=


--=-A2HJGaIfb/Z78I7wTL+8--
