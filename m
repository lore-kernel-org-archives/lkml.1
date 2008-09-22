Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYIVPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYIVPce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYIVPcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:32:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34937 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYIVPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:32:18 -0400
Subject: Re: [RFC v5][PATCH 8/8] Dump open file descriptors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Bastian Blank <bastian@waldi.eu.org>,
       containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <20080916230320.GA25445@us.ibm.com>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
	 <20080914095106.GA6300@wavehammer.waldi.eu.org>
	 <48CD3069.7080200@cs.columbia.edu>  <20080916230320.GA25445@us.ibm.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 08:31:40 -0700
Message-Id: <1222097500.8533.28.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren,

You should probably also cc the x86 maintainers on at least the
x86-specific bits.


-- Dave

