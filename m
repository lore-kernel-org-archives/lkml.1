Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXJAKAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXJAKAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXJAJ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:59:58 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:37484 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXJAJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:59:57 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miguel <mc354@tid.es>
Subject: Re: software unplug and plug USB
Date: Mon, 1 Oct 2007 11:58:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
References: <46FCF0F5.9030004@wpkg.org> <4700A44C.2010700@wpkg.org> <1191226692.6014.16.camel@McM>
In-Reply-To: <1191226692.6014.16.camel@McM>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011158.30051.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 01 Oktober 2007 schrieb Miguel:
> but only when I unplug and plug manually, the modem starts up ...
> Because of that i wanted to unplug/plug via scripting (software way)

You can use the bind & unbind attributes in sysfs.

	Regards
		Oliver

