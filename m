Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYD2DEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYD2DEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYD2DEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:04:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:43099 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYD2DEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CoXF/imdlrfgn1WFluxn3dUSdiJ7FLM1qImqZQYlk2dYf8X3e+zozrmBCRduznUUHC0NGlb3q/0IExav9xwnSJxeDZSaF83IQJ4CxO7bFxCHPj0VJs5eRN43ZrEEwUaNbjSph5cEISBmAascokbwFva3fb4z7y6flZRYZcJTcjY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: standalone kbuild's homepage?
Date: Tue, 29 Apr 2008 05:03:50 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290503.50545.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam, folks,

IIRC apart from in-kernel build system there is a "standalone"
one, which is targeted at other projects wishing to reuse
this excellent infrastructure.

I google for it for an hour or so, but all searches
inevitably bring me back to kernel's kbuild (doh!),
to http://sourceforge.net/projects/kbuild/ which is outdated,
or to http://svn.netlabs.org/kbuild (also wrong).

Please provide me with an URL you you know one.

Sorry for a bit of an OT.
--
vda
