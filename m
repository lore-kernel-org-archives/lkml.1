Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZBDK1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZBDK1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZBDK1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:27:21 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:44866 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZBDK1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:27:21 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: unknown symbols in 2.6.29-rc3
Date: Wed, 4 Feb 2009 11:28:14 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200901291023.32497.oliver@neukum.org> <20090202093226.fa883b13.randy.dunlap@oracle.com>
In-Reply-To: <20090202093226.fa883b13.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041128.15667.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 02 February 2009 18:32:26 schrieb Randy Dunlap:
> I don't see this error with your config file.
> Maybe you need to do a "make distclean" and rebuild everything?

Hi,

I did a pull again and the problem has gone away.

	Regards
		Oliver

