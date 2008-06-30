Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYF3I5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYF3I5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYF3I46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:56:58 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41158 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYF3I46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:56:58 -0400
Subject: Re: [PATCH 2/3] mmc: wbsd.c fix shadowing of 'dma' variable
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
	 <1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 10:57:07 +0200
Message-Id: <1214816227.11537.22.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> This patch fix warning :shadowing dma variable

please use module_param_named() instead.

Regards

Marcel


