Return-Path: <linux-kernel-owner+w=401wt.eu-S965602AbXA3QwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602AbXA3QwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965610AbXA3QwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:52:20 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:17649 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602AbXA3QwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:52:19 -0500
Date: Tue, 30 Jan 2007 17:50:38 +0100 (MET)
From: Oliver Neukum <oliver@neukum.name>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: question on resume()
User-Agent: KMail/1.9.1
Cc: nigel@nigel.suspend2.net
References: <200701291206.39637.oneukum@suse.de>
 <200701300010.38538.rjw@sisk.pl> <200701301732.56444.rjw@sisk.pl>
In-Reply-To: <200701301732.56444.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301750.48196.oliver@neukum.name>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 30. Januar 2007 17:32 schrieb Rafael J. Wysocki:
> However, you can always inspect the PF_FROZEN flag of the tasks in question
> if that's practicable.

What would I do with that information? Ignore completion of IO?

	Regards
		Oliver
